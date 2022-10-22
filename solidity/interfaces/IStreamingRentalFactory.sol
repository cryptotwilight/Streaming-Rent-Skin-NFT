// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.8.0 <0.9.0;

import { RentalSeed } from "./IStreamingRental.sol";

interface IStreamingRentalFactory { 

    function createRentalContract(RentalSeed memory _seed) payable external returns (address _rentalContract);

}