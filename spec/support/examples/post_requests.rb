shared_examples_for "valid_create" do |model, amount|
  it "should be successful" do
    expect{process :create, params: {model => attributes_for(model)} }.to change(model.to_s.classify.constantize, :count).by(amount)
  end

  it "return the new model as json" do
    process :create, params: {model => attributes_for(model)}

    expect(JSON.parse(response.body)).to eq(JSON.parse(model.to_s.classify.constantize.last.to_json))
  end

  it "should return a success status" do
    process :create, params: {model => attributes_for(model)}

    assert_response :success
  end
end

shared_examples_for "invalid_create" do |model, params|
  it "should be rejected" do
    expect{process :create, params: params}.to_not change(model.to_s.classify.constantize, :count)
  end

  it "should return an unprocessable entity status" do
    process :create, params: params

    assert_response :unprocessable_entity
  end
end

shared_examples_for "valid_update" do |model, params|

  it "should be successful" do
    process :update, params: { id: checked.id, model => params }
    checked.reload
    params.keys.each do |k|
      next if k.to_s.match(/password/)
      expect(checked.send(k)).to eq(params[k])
    end
  end

  it "should return a success status" do
    process :update, params: { id: checked.id, model => params }

    assert_response :success
  end

  it "should return the updated object" do
    process :update, params: { id: checked.id, model => params }
    checked.reload
    expect(JSON.parse(response.body)).to eq(JSON.parse(checked.to_json))
  end
end

shared_examples_for "invalid_update" do |model, params|
  it "should be rejected" do
    before = checked
    process :update, params: { id: checked.id, model => params }
    params.keys.each do |k|
      next if k.to_s.match(/password/)
      expect(checked.send(k)).to eq(before.send(k))
    end
  end

  it "should return a unprocessable entity status" do
    process :update, params: { id: checked.id, model => params }

    assert_response :unprocessable_entity
  end
end

shared_examples_for "unauthorized_update" do |model, params|
  it "should throw an error" do
    expect {process :update, params: { id: checked.id, model => params }}.to raise_error(NoMethodError)
  end
end
