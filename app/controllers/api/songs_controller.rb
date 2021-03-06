# app/controllers/api/songs_controller.rb

class Api::SongsController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :set_artist

  # For some reason,
  #   show/index,
  #   ActiveRecordSerializer only returns :id's :-(
  # Oh, might have something to do with song_serializer-
  # Use old skool rendering, don't trust new skool right now
  def create
    song = Song.new(song_params)
    song.artist_id = @artist.id

    if song.save
      render status: 201, json: {
        message: 'Song successfully created',
        song: song
      }.to_json
    else
      render status: 422, json: {
        errors: song.errors
      }.to_json
    end
  end

  def destroy
    song = Song.find(params[:id])
    song.destroy

    render status: 200, json: {
      message: 'Song successfully deleted'
    }.to_json
  end

private

  def set_artist
    @artist = Artist.find(params[:artist_id])
  end

  def song_params
    params.require(:song).permit(:title, :artist_id)
  end
end
