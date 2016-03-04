module UsersHelper
  def user_homepage_link(user)
    "<a href=\"/u/#{user.domain}\" title='查看Ta捐赠的全部图书'>#{user.nickname_}</a>"
  end
end