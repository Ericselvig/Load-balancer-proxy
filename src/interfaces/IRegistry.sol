// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

interface IRegistry {
    
    //////////////
    /// ERRORS ///
    //////////////
    error Registry__ZeroAddress();

    //////////////
    /// EVENTS ///
    //////////////
    event ImplementationAddedOrChanged(uint256 indexed id, address indexed implementation);
    event ImplementationRemoved(uint256 indexed id);

    /////////////////
    /// FUNCTIONS ///
    /////////////////

    /**
     * @notice Add or change the implementation address for a given id
     * @dev Only owner is allowed to call this function
     * @param _id The id of the implementation
     * @param _newImplementation The address of the implementation
     */    
    function addOrChangeImplementation(uint256 _id, address _newImplementation) external;

    /**
     * @notice Remove the implementation address for a given id
     * @dev Only owner is allowed to call this function
     * @param _id The id of the implementation
     */
    function removeImplementation(uint256 _id) external;

    /**
     * @notice Get the implementation address for a given id
     * @param _id The id of the implementation
     */
    function getImplementationAddress(uint256 _id) external view returns (address implementation);
}
