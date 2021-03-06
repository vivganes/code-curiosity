require "test_helper"

class OrganizationsControllerTest < ActionController::TestCase

  let(:org) { 'joshsoftware' }
  let(:request_path) { "/orgs/#{org}" }
  let(:body) { File.read('test/fixtures/org.json') }
  let(:status) { 200 }

  def get_stub
    stub_get(request_path).to_return(body: body, status: status,
      headers: {content_type: "application/json; charset=utf-8"})
  end

  def setup
    super
    get_stub
    @goal = create :goal
    @round = create :round, :open
    @user = create :user, auth_token: Faker::Lorem.word, goal: @goal
    @org = create :organization
    @org.users << @user
    @repo = create :repository_with_activity_and_commits, organization: @org
  end

  test 'index' do
    skip 'Route not defined'
    sign_in @user
    get :index
    assert_response :success
    assert_template :index
  end

  test 'edit' do
    sign_in @user
    get :edit, id: @org.id
    assert_response :success
    assert_template :edit
  end

  test 'update' do
    sign_in @user
    patch :update, id: @org.id, organization: {"name"=>"Josh Software Private Limited", "website"=>"www.joshsoftware.com", "company"=>"", "email"=>"", "description"=>"Ruby on Rails Experts"}
    assert_response :redirect
    assert_redirected_to organization_path(@org)
    org = assigns(:org)
    assert_equal org.name, 'Josh Software Private Limited'
    assert_equal org.website, 'www.joshsoftware.com'
    assert_equal org.description, 'Ruby on Rails Experts'
  end

  test 'show' do
    sign_in @user
    get :show, id: @org.id
    assert_response :success
    assert_template :show
  end

  test 'commits' do
    commit = create :commit, organization: @org, round: @round, commit_date: Date.yesterday
    sign_in @user
    get :commits, id: @org.id
    assert_response :success
    assert_template :commits
    assert_includes assigns(:commits).to_a, commit
  end

  test 'activities' do
    #skip 'Need test case'
    sign_in @user
    get :activities, id: @org.id
    assert_response :success
    assert_template :activities
  end
end
