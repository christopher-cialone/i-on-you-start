// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@chainlink/contracts/src/v0.8/ChainlinkClient.sol";
import "@chainlink/contracts/src/v0.8/VRFConsumerBase.sol";

contract ReviewSystem is ChainlinkClient, VRFConsumerBase {
    // Chainlink configurations
    address private oracle;
    bytes32 private jobId;
    uint256 private fee;

    // VRF configurations
    bytes32 internal keyHash;
    uint256 internal linkFee;

    struct Review {
        address user;
        string content;
        uint8 rating;
        uint256 timestamp;
    }

    mapping(address => Review[]) public reviews;
    mapping(bytes32 => address) public requestIdToUser;

    constructor(
        address _linkToken,
        address _oracle,
        bytes32 _jobId,
        uint256 _fee,
        address _vrfCoordinator,
        bytes32 _keyHash,
        uint256 _linkFee
    )
        VRFConsumerBase(_vrfCoordinator, _linkToken)
    {
        setChainlinkToken(_linkToken);
        oracle = _oracle;
        jobId = _jobId;
        fee = _fee;

        keyHash = _keyHash;
        linkFee = _linkFee;
    }

    function submitReview(address business, string memory content, uint8 rating) public {
        reviews[business].push(Review(msg.sender, content, rating, block.timestamp));
    }

    function requestRandomnessForReward() public returns (bytes32 requestId) {
        require(LINK.balanceOf(address(this)) >= linkFee, "Not enough LINK");
        requestId = requestRandomness(keyHash, linkFee);
        requestIdToUser[requestId] = msg.sender;
    }

    function fulfillRandomness(bytes32 requestId, uint256 randomness) internal override {
        address user = requestIdToUser[requestId];
        // Reward logic based on randomness
    }

    function fetchBusinessData(string memory query) public returns (bytes32 requestId) {
        Chainlink.Request memory request = buildChainlinkRequest(jobId, address(this), this.fulfill.selector);
        request.add("query", query);
        return sendChainlinkRequestTo(oracle, request, fee);
    }

    function fulfill(bytes32 _requestId, bytes32 _data) public recordChainlinkFulfillment(_requestId) {
        // Process the data fetched from off-chain
    }
}
