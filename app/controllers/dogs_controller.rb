class DogsController < ApplicationController
  before_action :set_dog, only: [:show, :edit, :update, :destroy]

  # GET /dogs
  # GET /dogs.json
  def index
    @sort = page_params[:sort]
    dog_query = @sort == 'true' ?  sort_by_likes_in_last_hour : Dog.all
    @dogs = dog_query.page(page_params[:page]).per(5)
  end

  def page_params
    params.permit(:page, :sort)
  end

  # GET /dogs/1
  # GET /dogs/1.json
  def show
  end

  # GET /dogs/new
  def new
    @dog = Dog.new
  end

  # GET /dogs/1/edit
  def edit
  end

  # POST /dogs
  # POST /dogs.json
  def create
    @dog = Dog.new(dog_params).tap { |dog| dog.owner = current_user }
    respond_to do |format|
      if @dog.save
        format.html { redirect_to @dog, notice: 'Dog was successfully created.' }
        format.json { render :show, status: :created, location: @dog }
      else
        format.html { render :new }
        format.json { render json: @dog.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /dogs/1
  # PATCH/PUT /dogs/1.json
  def update
    respond_to do |format|
      if @dog.owner == current_user
        if @dog.update(dog_params)
          format.html { redirect_to @dog, notice: 'Dog was successfully updated.' }
          format.json { render :show, status: :ok, location: @dog }
        else
          format.html { render :edit }
          format.json { render json: @dog.errors, status: :unprocessable_entity }
        end
      else
        format.html { render :edit }
        format.json { render json: @dog.errors, status: :forbidden }
      end
    end
  end

  # DELETE /dogs/1
  # DELETE /dogs/1.json
  def destroy
    @dog.destroy
    respond_to do |format|
      format.html { redirect_to dogs_url, notice: 'Dog was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_dog
    @dog = Dog.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def dog_params
    params.require(:dog).permit(:name, :description, images: [])
  end

  def sort_by_likes_in_last_hour
   ids = Dog.find_by_sql(
     <<~SQL
       SELECT dogs.id
       FROM dogs
         LEFT JOIN likes ON likes.dog_id = dogs.id
       GROUP BY dogs.id
       ORDER BY
         COUNT(
           CASE
           WHEN likes.created_at >= (datetime ('now', '-1 Hour')) THEN 1
           ELSE NULL
           END)
         DESC;
      SQL
     ).pluck(:id)
    order = ids.map.with_index {|id, i| "WHEN #{id} THEN #{i}"}.join(' ')
    order = "CASE ID #{order} END"
    Dog.where(id: ids).order(order)
  end
end
