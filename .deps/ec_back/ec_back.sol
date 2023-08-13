pragma solidity ^0.8.10;

// OpenZeppelinライブラリからIERC20インターフェイスをインポート
import "github.com/OpenZeppelin/zeppelin-solidity/contracts/token/ERC20/IERC20.sol";

contract PaymentGateway {
    struct Payment {
        bytes32 paymentId;      // 決済ID (UUID)
        bytes32 paymentHash;    // 決済ハッシュ
        bytes32 senderUuid;     // 送金者のUUID
        bytes32 recipientUuid;  // 受け取り者のUUID
        bool completed;         // 完了フラグ
    }

    mapping(bytes32 => Payment) public payments;

    function pay(
        address token,
        address to,
        uint256 amount,
        bytes32 paymentId,
        bytes32 paymentHash,
        bytes32 senderUuid,
        bytes32 recipientUuid
    ) public returns (bool) {
        IERC20 tokenContract = IERC20(token); // ERC20トークンコントラクト
        require(tokenContract.transferFrom(msg.sender, to, amount), "failed...");

        payments[paymentId] = Payment({
            paymentId: paymentId,
            paymentHash: paymentHash,
            senderUuid: senderUuid,
            recipientUuid: recipientUuid,
            completed: true
        });

        return true;
    }

    function getPayment(bytes32 paymentId) public view returns (Payment memory) {
        return payments[paymentId];
    }
}
