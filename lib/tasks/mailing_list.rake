namespace :mailing_list do
  task new_users: :environment do
    # Test - 0e3a83ce4d5e63c096dcba66ab210c13-us7
    # Knoda - 289a553dff319f2881c89d5c959b98eb-us7
    gb = Gibbon::API.new("289a553dff319f2881c89d5c959b98eb-us7")
    batch = []
    User.where('created_at > ?', 65.minutes.ago).each do |user|
      if user.email
        batch << {:email => {:email => user.email}, :merge_vars => {:USERNAME => user.username, :SIGNUP => user.created_at, :LOGIN => user.current_sign_in_at}}
      end
    end
    puts batch.size
    if batch.size > 0
      gb.lists.batch_subscribe(:id => '18ff2c715c', :batch => batch, :update_existing => true, :double_optin => false, :send_welcome => false)
    end
  end

  task updated_users: :environment do
    gb = Gibbon::API.new("289a553dff319f2881c89d5c959b98eb-us7")
    batch = []
    User.where('current_sign_in_at > ?', 25.hours.ago).each do |user|
      if user.email
        batch << {:email => {:email => user.email}, :merge_vars => {:USERNAME => user.username, :SIGNUP => user.created_at, :LOGIN => user.current_sign_in_at}}
      end
    end
    puts batch.size
    if batch.size > 0    
      gb.lists.batch_subscribe(:id => '18ff2c715c', :batch => batch, :update_existing => true, :double_optin => false, :send_welcome => false)
    end
  end  

end
