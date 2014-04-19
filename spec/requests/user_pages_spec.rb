require 'spec_helper'

describe "User pages" do
  subject { page }
  describe "signup page" do
    before() do
      visit signup_path
    end
    it { should have_selector('h1', text: 'Sign up') }
    it { should have_selector('title', text: full_title('Sign up')) }
  end

#   describe "profile page" do
# # Code to make a user variable
#     let(:foobar) { FactoryGirl.create(:user) }
#     before do
#       visit users_path(user)
#     end
#     it { should have_selector('h1',text: foobar.name) }
#     it { should have_selector('title', text: foobar.name) }
#   end

  describe "signup" do

    before do
      visit signup_path
    end

    let(:submit) { "Create my account" }

    describe "with invalid information" do
      it "should not create a user" do
        expect { click_button submit }.not_to change(User, :count)
      end

      describe "after saving the user" do
        before do
          click_button submit
        end
        it { should have_selector('title', text: 'Sign up') }
        it { should have_content('error') }
        it { should_not have_content('Password digest') }

      end

    end

    describe "with valid information" do
      before do
        fill_in "Name", with: "Example User"
        fill_in "Email", with: "user@example.com"
        fill_in "Password", with: "foobar"
        fill_in "Confirmation", with: "foobar"
      end

      it "should create a user" do
        expect { click_button submit }.to change(User, :count).by(1)
      end

      describe "after saving the user" do
        before do
          click_button submit
        end
        let(:user) { User.find_by_email('user@example.com') }
        it { should have_selector('title', text: user.name) }
        it { should have_selector('div.alert.alert-success', text: 'Welcome') }
        it { should have_link('Sign out') }

      end
    end
  end
end