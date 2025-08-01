class SearchController < ApplicationController
   def create
    query = params[:query].to_s.strip
    ip = request.remote_ip

    recent_search = Search.where(ip_address: ip)
                          .where("updated_at <= ?", 3.minutes.ago)
                          .order(updated_at: :desc)
                          .first

    if recent_search
      recent_search.update(query: query)
    else
      Search.create!(query: query, ip_address: ip)
    end

    head :ok
  end

  def index
    ip = request.remote_ip
    @top_queries = Search.where(ip_address: ip).group(:query).order('count_all DESC').limit(10).count
  end

  def analytics
      ip = request.remote_ip
      top_queries = Search.where(ip_address: ip)
                          .group(:query)
                          .order('count_all DESC')
                          .limit(10)
                          .count

      render json: top_queries
  end
end
