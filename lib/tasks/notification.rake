namespace :notification do
  
  task invitation: :environment do
      invitations = Invitation.unnotified
      invitations.each do |i|
        i.send_invite()
      end
  end

end
