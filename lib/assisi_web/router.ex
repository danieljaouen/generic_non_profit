defmodule AssisiWeb.Router do
  use AssisiWeb, :router
  use Coherence.Router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug Phoenix.LiveView.Flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :put_layout, {AssisiWeb.LayoutView, :app}
    plug Coherence.Authentication.Session
  end

  pipeline :protected do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug Phoenix.LiveView.Flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :put_layout, {AssisiWeb.LayoutView, :app}
    plug Coherence.Authentication.Session, protected: true
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/" do
    pipe_through :browser
    coherence_routes()
  end

  scope "/" do
    pipe_through :protected
    coherence_routes(:protected)
  end

  scope "/", AssisiWeb do
    pipe_through :browser
    get "/", PageController, :index
  end

  scope "/", AssisiWeb do
    pipe_through :protected

    live("/students", StudentsLive)
    resources "/students", StudentController
    resources "/classes", ClassController
    resources "/series", SeriesController
    resources "/drop_ins", DropInController
    resources "/floaters_passes", FloatersPassController
    resources "/first_times", FirstTimeController
    resources "/donations", DonationController
  end

  # Other scopes may use custom stacks.
  # scope "/api", AssisiWeb do
  #   pipe_through :api
  # end
end
