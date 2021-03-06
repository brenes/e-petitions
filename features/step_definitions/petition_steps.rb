Given /^a set of petitions for the "([^"]*)"$/ do |department_name|
  3.times do |x|
    @petition = Factory(:open_petition, :title => "Petition #{x}", :description => "description", :department => Department.find_by_name(department_name))
  end
end

Then /^I am taken to a landing page$/ do
  page.should have_content("Thank you")
end


Given /^a(n)? ?(pending|validated|open)? petition "([^"]*)" belonging to the "([^"]*)"$/ do |a_or_an, state, petition_title, department_name|
  @petition = Factory(:open_petition,
    :title => petition_title,
    :department => Department.find_by_name(department_name),
    :closed_at => 1.day.from_now,
    :state => state || "open")
end

Given /^the petition "([^"]*)" has (\d+) validated and (\d+) pending signatures$/ do |title, no_validated, no_pending|
  petition = Petition.find_by_title(title)
  (no_validated - 1).times { petition.signatures << Factory(:validated_signature) }
  no_pending.times { petition.signatures << Factory(:pending_signature) }
end

Given /^(\d+) petitions exist with a signature count of (\d+)$/ do |number, count|
  number.times do
    p = Factory(:open_petition)
    p.update_attribute(:signature_count, count)
  end
end

Given /^the petition "([^"]*)" has (\d+) validated signatures$/ do |title, no_validated|
  petition = Petition.find_by_title(title)
  (no_validated - 1).times { petition.signatures << Factory(:validated_signature) }
end

Given /^a petition "([^"]*)" belonging to the "([^"]*)" has been closed$/ do |petition_title, department_name|
  @petition = Factory(:open_petition, :title => petition_title, :closed_at => 1.day.ago, :department => Department.find_by_name(department_name))
end

Given /^a libelous petition "([^"]*)" has been rejected by the "([^"]*)"$/ do |petition_title, department_name|
  @petition = Factory(:petition,
    :title => petition_title,
    :department => Department.find_by_name(department_name),
    :state => Petition::HIDDEN_STATE,
    :rejection_code => "libellous",
    :rejection_text => "You can't say that!")
end

Given /^a petition "([^"]*)" has been rejected by the "([^"]*)"( with the reason "([^"]*)")?$/ do |petition_title, department_name, reason_or_not, reason|
  reason_text = reason.nil? ? "We are the #{department_name}, not television executives" : reason
  @petition = Factory(:petition,
    :title => petition_title,
    :department => Department.find_by_name(department_name),
    :state => Petition::REJECTED_STATE,
    :rejection_code => "irrelevant",
    :rejection_text => reason_text)
end

When /^I view the petition$/ do
  visit petition_path(@petition)
end

When /^I view all petitions from the home page$/ do
  visit home_path
  click_link "View all"
end

When /^I check my petition title$/ do
  within(:css, "form#pre_creation_search") do
    fill_in "search", :with => "Rioters should loose benefits"
    click_button("Search")
  end
end

When /^I choose to create a petition anyway$/ do
  click_link_or_button "Create e-petition"
end

When /^I change the number viewed per page to (\d+)$/ do |per_page|
  select per_page.to_s, :from => 'per_page'
end

Then /^I should see petitions for all departments$/ do
  page.should have_content("All e-petitions")
  page.should have_css("tbody tr", :count => 6)
end

Then /^I should see the petition details$/ do
  page.should have_content(@petition.title)
  page.should have_content(@petition.description)
end

Then /^I should see the vote count, closed and open dates$/ do
  @petition.reload
  page.should have_css("dd.signature_count", :text => @petition.signature_count.to_s)
  page.should have_css("dd.created_by", :text => @petition.creator_signature.name)
  page.should have_css("dd.closing_date", :text => @petition.closed_at.to_s(:dotted_short_date))
end

Then /^I should see the reason for rejection$/ do
  @petition.reload
  page.should have_content(@petition.rejection_text)
end

And /^all petitions have had their signatures counted$/ do
  Petition.update_all_signature_counts
end

Then /^I should be asked to search for a new petition$/ do
  page.should have_css("form#pre_creation_search input#search")
end

Then /^I should see a list of existing petitions I can sign$/ do
  page.should have_content(@petition.title)
end

Then /^I should see a list of (\d+) petitions$/ do |petition_count|
  page.should have_css("tbody tr", :count => petition_count)
end

Then /^I should see my search query already filled in as the title of the petition$/ do
  page.should have_css("input[value='#{@petition.title}']")
end

Then /^I can click on a link to return to the petition$/ do
  page.should have_css("a[href*='/petitions/#{@petition.id}']")
end
