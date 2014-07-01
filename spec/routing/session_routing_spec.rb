require "spec_helper"

describe "session routes", :type => :routing do

  it "routes post /auth/:provider/callback to the session controller create action" do
    expect(post("/auth/developer/callback")).to route_to( controller: "session",
                                                          action: "create",
                                                          provider: 'developer')
  end

  it "does routes get /sign_out" do
    expect(get('/sign_out')).to route_to( controller: "session",
                                          action: "destroy")
  end
end
