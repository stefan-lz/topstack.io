require "spec_helper"

describe "absorb routes", :type => :routing  do

  it "routes get /absorbs/:id to the absorb controller show action" do
    expect(get("/absorb/45")).to route_to( controller: "absorb",
                                           action:     "show",
                                           id:         "45")
  end

  it "routes put /absorbs/:id to the absorb controller update action" do
    expect(put("/absorb/12")).to route_to( controller: "absorb",
                                           action:     "update",
                                           id:         "12")
  end

  it "does not route delete /absorbs/:id" do
    expect(delete("/absorb/45")).to_not be_routable
  end

  it "routes post /absorbs to the absorb controller create action" do
    expect(post("/absorb")).to route_to( controller: "absorb",
                                         action:     "create")
  end

  it "routes get /top-10/javascript+rails/this-week to the absorb controller index action" do
    expect(get("/top-10/javascript+rails/this-week")).to route_to( controller: "absorb",
                                                                   action:     "index",
                                                                   top:        "top-10",
                                                                   tags:       "javascript+rails",
                                                                   time_range: "this-week")
  end

  it "routes get /top-10/javascript+rails to the absorb controller index action" do
    expect(get("/top-10/javascript+rails")).to route_to( controller:     "absorb",
                                                         action:         "index",
                                                         top:            "top-10",
                                                         unknown_filter: "javascript+rails")
  end

  it "routes get /top-10/this-week to the absorb controller index action" do
    expect(get("/top-10/this-week")).to route_to( controller:     "absorb",
                                                  action:         "index",
                                                  top:            "top-10",
                                                  unknown_filter: "this-week")
  end

end
