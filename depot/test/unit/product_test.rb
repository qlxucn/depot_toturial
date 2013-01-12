require 'test_helper'

class ProductTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  test "product's attributes must NOT be empty" do
    product = Product.new
    assert product.invalid?, "must be invalid"
    assert product.errors[:title].any?
    assert product.errors[:description].any?
    assert product.errors[:price].any?
    assert product.errors[:image_url].any?

  end

  test "price must be positive" do
    product = Product.new(:title=>"my title",
                          :description  => "my desc",
                          :image_url =>  "111.jpg")
    product.price = -1
    assert product.invalid?
    assert_equal "must be greater than or equal to 0.01", product.errors[:price].join('; ')

    product.price = 0
    assert product.invalid?
    assert_equal "must be greater than or equal to 0.01", product.errors[:price].join('; ')

    product.price = 1
    assert product.valid?

  end

  test "title must be unique" do
    product = Product.new(:title=>products(:one).title, #using data in Fixture
                          :description  => "my desc",
                          :price => 1,
                          :image_url =>  "111.jpg")
    assert product.invalid?
    assert_equal I18n.translate('activerecord.errors.messages.taken'), product.errors[:title].join('; ')
  end

  #validates :image_url, :format => {:with => %r{\.(gif|jpg|png)$}i, :message => 'must be a URL for GIF, JPG or PNG image.'}
  test "image must be gif|jpg|png" do
    ok = %w{ fred.gif fred.jpg fred.png FRED.JPG FRED.Jpg http://a.b.c/x/y/z/fred.gif }
    bad = %w{ fred.doc fred.gif/more fred.gif.more }


    ok.each do |name|
      assert new_product(name).valid?, "#{name} shouldn't be invalid"
    end

    bad.each do |name|
      assert new_product(name).invalid?, "#{name} shouldn't be valid"
    end
  end

  def new_product(image_url)
    Product.new(:title => "My Book Title",
                :description => "yyy", :price => 1, :image_url => image_url)
  end

end
