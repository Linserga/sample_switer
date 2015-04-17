require "rails_helper"

RSpec.describe UserMailer, type: :mailer do
  
  let(:user) { FactoryGirl.create(:user)}

  describe "account_activation" do
    let(:mail) { UserMailer.account_activation (user)}

    it "renders the headers" do
      expect(mail.subject).to eq("Account activation")
      expect(mail.to).to eq([user.email])
      expect(mail.from).to eq(["noreply@example.com"])
    end

    it "renders the body" do
      expect(mail.body.encoded).to match("Hi")
    end
  end

  context "password_reset" do
    it "renders the headers" do
    	user.reset_token = User.new_token
    	mail = UserMailer.password_reset(user)
      expect(mail.subject).to eq("Password reset")
      expect(mail.to).to eq([user.email])
      expect(mail.from).to eq(["noreply@example.com"])
      expect(mail.body.encoded).to match(CGI::escape(user.email))
      expect(mail.body.encoded).to match(user.reset_token)
    end
  end

end
