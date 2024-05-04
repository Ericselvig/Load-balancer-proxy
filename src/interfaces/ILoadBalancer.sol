// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

/**
 * @title ILoadBalancer
 * @author Yash Goyal
 * @notice Interface for the LoadBalancer contract
 */
interface ILoadBalancer {
    //////////////
    /// ERRORS ///
    //////////////

    error LoadBalancer__ImplementationNotFound();
    error LoadBalancer__DelegateCallError();

    /////////////////
    /// FUNCTIONS ///
    /////////////////

    /**
     * @notice change or add a new implementation address for a given id in the registry contract
     * @dev only owner is allowed to call this function
     * @param _id The id of the implementation
     * @param _newImplementation The addres of the new implementation
     */
    function addOrChangeImplementation(uint256 _id, address _newImplementation) external;

    /**
     * @notice Remove the implementation address for a given id in the reistry contract
     * @dev only owner is allowed to call this function
     * @param _id The id of the implementation
     */
    function removeImplementation(uint256 _id) external;

    /**
     * @notice Get the implementation address for a given id
     * @dev This function is used to get the implementation address for a given id
     * @param _id The id of the implementation
     */
    function getImplementationAddress(uint256 _id) external view returns (address implementation);
}
