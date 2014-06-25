class NotesController < ApplicationController

  def new
    @user = current_user
    @note = @user.notes.build
  end

  def create
    @user = current_user
    @note = @user.notes.build(note_params)
    if @note.save
      redirect_to user_notes_path
    else
      render 'new'
    end
  end

  def edit
    @user = current_user
    @note = @user.notes.find(params[:id])
  end

  def update
    @user = current_user
    @note = @user.notes.find(params[:id])
    if @note.update(note_params)
      redirect_to user_notes_path
    else
      render 'edit'
    end
  end

  def index
    @user = current_user
    @notes = @user.notes.all
  end

  private

    def note_params
      params.require(:note).permit(:note_item, :date)
    end
end
