class LikesController < ApplicationController
  before_action :set_dog, only: [:create]
  before_action :set_like, only: [:destroy]

  def create
    Like.create(dog: @dog, user: current_user)
    redirect_back(fallback_location: @dog )
  end

  def destroy
    @like.destroy if @like
    redirect_back(fallback_location: @dog )
  end

  private

  def set_like
    @like = Like.find(params[:id])
  end

  def set_dog
    @dog = Dog.find(params[:dog_id])
  end
end
