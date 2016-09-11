class HomeController < ApplicationController
  def index
  end

  def result
    @image = Image.create(file: params[:file])

    require 'rest_client'
    response = RestClient.post("https://gateway-a.watsonplatform.net/visual-recognition/api/v3/classify?api_key=#{$BLUEHUB_API_KEY}&version=2016-09-11",
                    :images_file => File.new(@image.file.path),
                    :parameters => File.new('public/french_toast.json'))

    @response = JSON.parse(response)
    answer = @response['images'][0]['classifiers'][1]['classes'].sort_by {|ele| ele[:score] }.last["class"]

    @shop = Shop.find_by(shop_id: answer)
  end
end
