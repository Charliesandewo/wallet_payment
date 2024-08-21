module Teams
  module Wallets
    # handle team withdrawing from their wallet
    class WithdrawManager
      def self.execute(params:, current_team:)
        wallet = Wallet.find_by(entity: current_team)

        validator = ::Wallets::WithdrawValidator.new(params:, wallet:)
        raise StandardError.new(validator.errors.messages) if validator.invalid?

        top_up_transaction = Transactions::WithdrawService.execute(
          wallet:,
          amount: params[:amount]
        )

        Wallet.transaction do
          top_up_transaction.save!
        end
        wallet
      end
    end
  end
end
