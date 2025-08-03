// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Veripharm {

    event LogMessage(string message);

    function logEvent(string memory message) public {
        emit LogMessage(message);
    }

    enum Role { Unassigned, Manufacturer, Distributor, Pharmacist }

    mapping(address => Role) public roles;

    event Log(string message);

    modifier onlyRole(Role _role) {
        require(roles[msg.sender] == _role, "Access denied for this role");
        _;
    }

    function assignRole(address _user, Role _role) public {
        roles[_user] = _role;
    }

    function logDrugCreated(
        string memory _batchId,
        string memory _drugName,
        uint256 _quantity
    ) public onlyRole(Role.Manufacturer) {
        emit Log(
            string(
                abi.encodePacked(
                    "Manufacturer (",
                    toAsciiString(msg.sender),
                    ") created ",
                    uintToString(_quantity),
                    " drugs (",
                    _batchId,
                    ") of ",
                    _drugName
                )
            )
        );
    }

    function logTransfer(
        string memory _batchId,
        string memory _toRole,
        address _to
    ) public {
        emit Log(
            string(
                abi.encodePacked(
                    toAsciiString(msg.sender),
                    " transferred ",
                    _batchId,
                    " to ",
                    _toRole,
                    " (",
                    toAsciiString(_to),
                    ")"
                )
            )
        );
    }

    function logVerification(
        string memory _batchId,
        bool isVerified
    ) public {
        emit Log(
            string(
                abi.encodePacked(
                    "Drug ",
                    _batchId,
                    isVerified ? " verified as authentic" : " failed verification"
                )
            )
        );
    }

    // --------------------------
    // Utility Functions Below
    // --------------------------

    function uintToString(uint256 v) internal pure returns (string memory) {
        if (v == 0) return "0";
        uint256 j = v;
        uint256 length;
        while (j != 0) {
            length++;
            j /= 10;
        }
        bytes memory bstr = new bytes(length);
        uint256 k = length;
        while (v != 0) {
            k--;
            bstr[k] = bytes1(uint8(48 + v % 10));
            v /= 10;
        }
        return string(bstr);
    }

    function toAsciiString(address x) internal pure returns (string memory) {
        bytes memory s = new bytes(42);
        s[0] = '0';
        s[1] = 'x';
        for (uint256 i = 0; i < 20; i++) {
            bytes1 b = bytes1(uint8(uint256(uint160(x)) / (2**(8*(19 - i)))));
            bytes1 hi = bytes1(uint8(b) / 16);
            bytes1 lo = bytes1(uint8(b) - 16 * uint8(hi));
            s[2*i + 2] = char(hi);
            s[2*i + 3] = char(lo);
        }
        return string(s);
    }

    function char(bytes1 b) internal pure returns (bytes1 c) {
        if (uint8(b) < 10) return bytes1(uint8(b) + 48);
        else return bytes1(uint8(b) + 87);
    }
}
