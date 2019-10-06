# frozen_string_literal: true

When('下記のパスにGETメソッドでアクセスする:') do |path|
  visit path
end

Then('ステータスコード{string}が返る') do |code|
  expect(page.status_code).to eq code.to_i
end

Then('Content-Typeが{string}である') do |content_type|
  expect(page.response_headers['Content-Type']).to eq content_type
end

Then('レスポンスボディに下記のテンプレートが表示されている:') do |table|
  table.hashes.each do |hash|
    expected_string = "# Kiribori Template for #{hash['テンプレート']}"
    case hash['含まれているか']
    when '○'
      expect(page.body).to include expected_string
    when '×'
      expect(page.body).not_to include expected_string
    else
      p hash
    end
  end
end

Then("レスポンスボディに下記の文字列が含まれている:") do |string|
  expect(page.body).to include string
end
