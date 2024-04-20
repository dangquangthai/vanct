# frozen_string_literal: true

class PurchasesController < ApplicationController
  def show
    @purchase = Purchase.find(params[:purchase_id])

    respond_to do |format|
      format.turbo_stream
    end
  end

  def update
    @purchase = Purchase.find(params[:purchase_id])
    @purchase.update(paid: !purchase.paid)

    respond_to do |format|
      format.turbo_stream
    end
  end
end
