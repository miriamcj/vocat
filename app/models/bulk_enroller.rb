class BulkEnroller

  attr_accessor :inviter

  # Enrolls all emails in course with role
  # Contacts is a string of emails/names that can be split on newlines
  # Course is a course object
  # Role is a string or symbol
  # If allow invites is true, then users who don't exist in VOCAT will be invited.
  # Returns an array of contact hashes with information about what was created.
  def enroll(contacts, course, role, allow_invites = false)
    results = Array.new
    contacts.strip.split(/\r?\n/).each do |contact|
      results.push(enroll_contact(contact, course, role, allow_invites))
    end
    results
  end

  def initialize
    self.inviter = Inviter.new
  end

  private

  def contact_hash(contact_string)
    {
        email: nil,
        first_name: nil,
        last_name: nil,
        action: nil,
        success: nil,
        reason: nil,
        message: nil,
        string: contact_string,
    }
  end

  def clean_contact!(contact)
    contact.strip!
    contact
  end

  def parse_name!(contact, name)
    unless name.nil?
      position = name.rindex(' ')
      parts = position != nil ? [name[0...position], name[position+1..-1]] : [name]
      contact[:first_name] = parts[0]
      contact[:last_name] = parts[1]
    end
  end

  def parse_email!(contact, email)
    unless email.nil?
      email.strip!
      contact[:email] = email
    end
  end

  def parse_comma_delimited_contact(contact_string)
    if contact_string.include? ','
      parts = contact_string.split(',').collect{|part| part.strip}
      contact = contact_hash(contact_string)
      parse_name!(contact, parts[0])
      parse_email!(contact, parts[1])
      return contact
    else
      return nil
    end
  end

  def parse_osx_style_contact(contact_string)
    if contact_string.include?('<') && contact_string.include?('>')
      _,name,email =  /\A\s*(\S+.*\S+)\s*\<([^\>]+)\>/.match(contact_string).to_a
      contact = contact_hash(contact_string)
      parse_name!(contact, name)
      parse_email!(contact, email)
      return contact
    else
      return nil
    end
  end

  def parse_email_only_contact(contact_string)
    if contact_string.include?('@')
      contact = contact_hash(contact_string)
      parse_email!(contact, contact_string)
      return contact
    else
      return nil
    end
  end

  def parse_contact(contact_string)
    clean_contact!(contact_string)
    contact = parse_comma_delimited_contact(contact_string)
    contact = parse_osx_style_contact(contact_string) if contact.nil?
    contact = parse_email_only_contact(contact_string) if contact.nil?
    if contact.nil?
      contact = contact_hash(contact_string)
    end
    return contact
  end

  def get_contact_user(contact)
    User.where("lower(email) = ?", contact[:email].downcase).take
  end

  def enrollable?(contact)
    user = get_contact_user(contact)
    user.nil? ? false : true
  end

  def invitable?(contact)
    user = get_contact_user(contact)
    user.nil? ? true : false
  end

  def assign_action!(contact)
    if contact[:email].nil?
      contact[:success] = false
      contact[:reason] = :invalid
      contact[:message] = "\"#{contact[:string]}\" is invalid."
    elsif enrollable?(contact)
      contact[:action] = :enroll
    elsif invitable?(contact)
      contact[:action] = :invite
    end
  end

  def enroll_contact(contact, course, role, allow_invites)
    contact = parse_contact(contact)
    assign_action!(contact)
    attempt_action(contact, course, role, allow_invites)
    contact
  end

  def attempt_action(contact, course, role, allow_invites)
    case contact[:action]
      when :enroll
        enroll_one_contact!(contact, course, role)
      when :invite
        invite_one_contact!(contact, allow_invites)
        if contact[:success] == true
          enroll_one_contact!(contact, course, role)
        end
    end
  end

  def enroll_one_contact!(contact, course, role)
    user = get_contact_user(contact)
    course.enroll(user, role)
    if user.errors.empty?
      contact[:success] = true
      contact[:message] = "#{user.name} has been enrolled in #{course.to_s}"
    else
      contact[:success] = false
      contact[:reason] = :enroll_failed
      contact[:message] = user.errors.full_messages.join(' ')
    end
  end

  def invite_one_contact!(contact, allow_invites)
    if allow_invites == true
      response = inviter.invite(contact[:email], contact[:first_name], contact[:last_name])
      if response[:success] == true
        contact[:success] = true
      else
        contact[:success] = false
        contact[:reason] = :invite_failed
        contact[:message] = response[:message]
      end
    else
      contact[:success] = false
      contact[:reason] = :must_confirm
      contact[:message] = 'Please confirm that you would like to invite this user.'
    end
  end


end