# -*- coding: utf-8 -*-
class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception


  # See http://ar156.dip.jp/tiempo/publish/52
  #     http://morizyun.github.io/blog/custom-error-404-500-page/
  #==========================================================
  # 例外ハンドル
  # Strong parameters エラーは 400 エラーを表示する
  rescue_from ActionController::ParameterMissing, ActionController::UnpermittedParameters, :with => :render_400

  # ArgumentError (invalid %-encoding) は 400 エラーを表示する
  rescue_from ArgumentError, :with => :render_400

  def render_400(exception = nil)
    render :file => 'errors/error_400', :status => 400, :layout => 'application'
  end

  def render_404(exception = nil)
    render :file => 'errors/error_404', :status => 404, :layout => 'application'
  end

end
