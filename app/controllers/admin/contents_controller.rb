module Admin
  class ContentsController < BaseController
    before_action :set_content, only: %i[ show edit update destroy ]

    # GET /admin/contents or /admin/contents.json
    def index
      @contents = Content.all
    end

    # GET /admin/contents/1 or /admin/contents/1.json
    def show
    end

    # GET /admin/contents/new
    def new
      @content = Content.new
    end

    # GET /admin/contents/1/edit
    def edit
    end

    # POST /admin/contents or /admin/contents.json
    def create
      @content = Content.new(content_params)

      respond_to do |format|
        if @content.save
          format.html { redirect_to [:admin, @content], notice: "Content was successfully created." }
          format.json { render :show, status: :created, location: @content }
        else
          format.html { render :new, status: :unprocessable_entity }
          format.json { render json: @content.errors, status: :unprocessable_entity }
        end
      end
    end

    # PATCH/PUT /admin/contents/1 or /admin/contents/1.json
    def update
      respond_to do |format|
        if @content.update(content_params)
          format.html { redirect_to [:admin, @content], notice: "Content was successfully updated." }
          format.json { render :show, status: :ok, location: @content }
        else
          format.html { render :edit, status: :unprocessable_entity }
          format.json { render json: @content.errors, status: :unprocessable_entity }
        end
      end
    end

    # DELETE /admin/contents/1 or /admin/contents/1.json
    def destroy
      @content.destroy!

      respond_to do |format|
        format.html { redirect_to admin_contents_path, status: :see_other, notice: "Content was successfully destroyed." }
        format.json { head :no_content }
      end
    end

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_content
        @content = Content.find(params[:id])
      end

      # Only allow a list of trusted parameters through.
      def content_params
        params.require(:content).permit(:title, :body, :content_type, :status)
      end
  end
end
