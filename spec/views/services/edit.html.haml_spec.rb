require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/services/edit.html.haml" do
  include ServicesHelper

  before(:each) do
    assigns[:service] = @service = stub_model(Service,
      :new_record? => false,
      :name => "value for name",
      :kind => "value for kind",
      :value_cents => 1,
      :done => false
    )
  end

  it "renders the edit service form" do
    render

    response.should have_tag("form[action=#{service_path(@service)}][method=post]") do
      with_tag('input#service_name[name=?]', "service[name]")
      with_tag('input#service_kind[name=?]', "service[kind]")
      with_tag('input#service_value_cents[name=?]', "service[value_cents]")
      with_tag('input#service_done[name=?]', "service[done]")
    end
  end
end


