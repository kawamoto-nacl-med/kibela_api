class KibelaApi
  CustomEmoji = Struct.new(:create_user, :created_at, :emoji_code, :id, :image_url, :updated_at)

  # Mutation.createCustomEmojiを実行
  # @params [String] code 50文字の絵文字コード。英数字と_が使用可能。
  # @params [String] base64 BASE64でエンコードされた画像データURI。
  # @return [Hash] レスポンス。
  def create_custom_emoji(code, base64)
    query_str = <<~"GRAPHQL"
      mutation {
        createCustomEmoji(input: { emojiCode: "#{code}",imageDataUrl: "#{base64}" }) {
          clientMutationId
        }
      }
    GRAPHQL
    query = generate_query(query_str)
    request(query)
  end

  # @return [Array<CustomEmoji>]
  def custom_emojis
    query_str = <<~"GRAPHQL"
      query {
        customEmojis(first: #{custom_emojis_count}) {
          nodes { createUser { account }, createdAt, emojiCode, id, imageUrl, updatedAt }
        }
      }
    GRAPHQL
    query = generate_query(query_str)
    response = request(query)
    response[:data][:customEmojis][:nodes].map do |node|
      CustomEmoji.new(node.dig(:createUser, :account), node[:createdAt],
                      node[:emojiCode], node[:id], node[:imageUrl], node[:updatedAt])
    end
  end

  # @return [Integer] 登録されているカスタム絵文字の総数。
  def custom_emojis_count
    query_str = <<~"GRAPHQL"
      query {
        customEmojis {
          totalCount
        }
      }
    GRAPHQL
    query = generate_query(query_str)
    request(query)[:data][:customEmojis][:totalCount]
  end
end
