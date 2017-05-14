require 'test_helper'
require 'az_collection_template_test_helper'

class AzCollectionTemplateTest < ActiveSupport::TestCase
  
  #include Authorization::TestHelper

  test "Create correct AzCollectionTemplate" do
    Authorization.current_user = nil

    assert is_table_size_equal?(AzCollectionTemplate, 0)

    user = prepare_user(:user)
    assert_not_nil user

    company = prepare_company(user)
    assert_not_nil company

    ctpl = create_collection_template(user, company, 'list')
    assert_not_nil ctpl

    assert is_table_size_equal?(AzCollectionTemplate, 1)
  end

  test "Create incorrect AzCollectionTemplate" do
    Authorization.current_user = nil

    user = prepare_user(:user)
    assert_not_nil user

    company = prepare_company(user)
    assert_not_nil company

    assert is_table_size_equal?(AzCollectionTemplate, 0)

    ctpl = create_collection_template(user, company, nil)
    assert_nil ctpl

    ctpl = create_collection_template(user, company, '')
    assert_nil ctpl

    assert is_table_size_equal?(AzCollectionTemplate, 0)
  end

  test "make_copy AzCollectionTemplate" do
    Authorization.current_user = nil

    user = prepare_user(:user)
    assert_not_nil user

    company = prepare_company(user)
    assert_not_nil company

    assert is_table_size_equal?(AzCollectionTemplate, 0)

    ctpl = create_collection_template(user, company, 'list')
    assert_not_nil ctpl

    assert is_table_size_equal?(AzCollectionTemplate, 1)


    # Копирование не должно приводить к возникновению новой записи.
    # Возвращается копируемая запись
    ctpl1 = ctpl.make_copy()

    assert ctpl1.id == ctpl.id
    
    assert is_table_size_equal?(AzCollectionTemplate, 1)
    
  end
   
end
