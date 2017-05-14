Factory.define :az_page do |page|
	page.sequence(:name) { |n| "page-#{n}" }
	page.sequence(:title) { |n| "page-title-#{n}" }
	page.sequence(:description) { |n| "page-description-#{n}" }
	page.sequence(:position) { |n| n }
	page.design_source nil
	page.functionality_source nil
  page.page_type AzPage::Page_user
  page.owner nil
  page.az_base_project nil
 	page.parents []
end
