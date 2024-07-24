// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract MockV3Aggregator {
    int256 private _latestAnswer;
    uint256 private _latestTimestamp;
    uint256 private _latestRound;

    event AnswerUpdated(
        int256 indexed current,
        uint256 indexed roundId,
        uint256 updatedAt
    );

    constructor(int256 initialAnswer) {
        _latestAnswer = initialAnswer;
        _latestTimestamp = block.timestamp;
        _latestRound = 1;
    }

    function latestAnswer() external view returns (int256) {
        return _latestAnswer;
    }

    function latestTimestamp() external view returns (uint256) {
        return _latestTimestamp;
    }

    function latestRound() external view returns (uint256) {
        return _latestRound;
    }

    function updateAnswer(int256 newAnswer) external {
        _latestAnswer = newAnswer;
        _latestTimestamp = block.timestamp;
        _latestRound++;
        emit AnswerUpdated(newAnswer, _latestRound, _latestTimestamp);
    }
}
