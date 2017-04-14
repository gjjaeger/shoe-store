require('pry')
require("bundler/setup")
require('pg')

DB = PG.connect({:dbname => "shoe_store_development"})
  Bundler.require(:default)

  Dir[File.dirname(__FILE__) + '/lib/*.rb'].each { |file| require file }
  also_reload("lib/*.rb")

get('/') do
  # average_rating= @store.ratings.average("score").to_f
  @topstores = DB.exec("select stores.* ,avg(score) from ratings join stores on (stores.id = ratings.store_id) group by stores.id order by avg(score) desc;")
  @stores = Store.all()
  @ratings = Rating.all
  @brands = Brand.all
  erb(:index)
end

get ('/store/:id/view/?') do
  @store=Store.find(Integer(params.fetch('id')))
  @average_rating= @store.ratings.average("score").to_f
  @add_new_brand = params[:add_new_brand]
  @brands = Brand.all()
  erb(:store_view)
end

post ('/store') do
  name = params.fetch('name')
  address = params.fetch('address')
  store = Store.create({:name => name, :address => address})
  if store.save()
    redirect ('/')
  else
    erb(:errors)
  end
end

post ('/brand') do
  store_id = Integer(params.fetch('store_id'))
  store=Store.find(store_id)
  brand_id = Integer(params.fetch('brand'))
  brand = Brand.find(brand_id)
  StoresBrand.create(store: store, brand: brand)
  redirect("/store/#{store_id}/view/?")
end

post ('/brand/new') do
  store_id = Integer(params.fetch('store_id'))
  store=Store.find(store_id)
  brand_name = params.fetch('brand')
  brand_logo = params.fetch('logo')
  brand = Brand.create({:name=>brand_name, :brandimage => brand_logo})
  StoresBrand.create(store: store, brand: brand)
  redirect("/store/#{store_id}/view/?")
end

delete ('/brand') do
  store_id=Integer(params.fetch("store_id"))
  brand_id=Integer(params.fetch("brand_id"))
  brand_to_be_deleted= Brand.find(Integer(params.fetch('brand_id')))
  brand_to_be_deleted.destroy()
  redirect("/store/#{store_id}/view/?")
end

post ('/rating') do
  store_id = Integer(params.fetch('store_id'))
  name = params.fetch('user_name')
  rating = Integer(params.fetch('rating'))
  ing = Rating.create({:name => name,:score=>rating,:store_id => store_id})
  redirect("/store/#{store_id}/view/?")
end

get ('/brands') do
  @brands = Brand.all
  erb(:brands)
end

patch("/store/:id") do
  store_id=Integer(params.fetch('id'))
  name = params.fetch("name")
  address = params.fetch("address")
  @store = Store.find(params.fetch("id").to_i())
  @store.update({:name => name, :address => address})
  redirect("/store/#{store_id}/view/?")
end

get("/store/:id/edit") do
  @store = Store.find(params.fetch("id").to_i())
  erb(:store_edit)
end

delete("/store/:id") do
  store_id=Integer(params.fetch("id"))
  store_to_be_deleted= Store.find(store_id)
  store_to_be_deleted.destroy()
  redirect("/")
end
