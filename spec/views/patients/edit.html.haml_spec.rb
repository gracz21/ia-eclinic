require 'rails_helper'

RSpec.describe "patients/edit", type: :view do
  before(:each) do
    @patient = assign(:patient, Patient.create!(
      :firstName => "MyString",
      :lastName => "MyString",
      :pesel => "MyString",
      :address => "MyString"
    ))
  end

  it "renders the edit patient form" do
    render

    assert_select "form[action=?][method=?]", patient_path(@patient), "post" do

      assert_select "input#patient_firstName[name=?]", "patient[firstName]"

      assert_select "input#patient_lastName[name=?]", "patient[lastName]"

      assert_select "input#patient_pesel[name=?]", "patient[pesel]"

      assert_select "input#patient_address[name=?]", "patient[address]"
    end
  end
end
