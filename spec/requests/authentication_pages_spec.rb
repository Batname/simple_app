require 'spec_helper'

describe "Authentication" do

  subject { page }

  describe "signin page" do
    before do
      visit signin_path
    end

    it { should have_content('Sign in') }
    it { should have_selector('title', text: full_title('Sign in')) }
  end

  describe "signin" do
    before do
      visit signin_path
    end
    describe "with invalid information" do
      before do
        click_button "Sign in"
      end

      it { should have_selector('title', text: 'Sign in') }
      it { should have_error_message }

      describe "after visiting another page" do
        before do
          click_link "Home"
        end
        it { should_not have_error_message }
      end
    end

    describe "with valid information" do
      let(:user) { FactoryGirl.create(:user) }
      before do
        fill_in "Email",    with: user.email.upcase
        fill_in "Password", with: user.password
        click_button "Sign in"
      end

      it { should have_selector('title', text: user.name) }

      it { should have_link('Users',    href: users_path) }
      it { should have_link('Profile',  href: user_path(user)) }
      it { should have_link('Sign out', href: signout_path) }
      it { should_not have_link('Sign in', href: signin_path) }

      describe "followed by signout" do
        before do
          click_link "Sign out"
        end
        it { should_not have_link('Sign in') }
      end
    end
  end
end
