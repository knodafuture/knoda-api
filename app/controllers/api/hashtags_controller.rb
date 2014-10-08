class Api::HashtagsController < ApplicationController
  skip_before_filter :authenticate_user_please!
  include HashtagsConcern
end
