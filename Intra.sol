pragma solidity >=0.4.25 <0.6.0;

contract IntraDellBC
{
    enum StateType { 
      ItemAvailable,
      OrderAcceptedByW1,
      OrderAcceptedByW2,
      OrderForODM,
      OrderForSupplier,
      ShipFromSupplier,
      ItemSent
    }

    int public Quantity_W1 = 200;
    int public Quantity_W2 = 200;
    int public Quantity_ODM;
    int public Quantity_Part1_Supplier = 5000;
    int public Quantity_Part2_Supplier = 5000;
    int public Price;
    address public InstanceBuyer;
    address public InstanceSupplier;
    StateType public  State;
    string public Description;
    int public Quantity_Part1_Supplier_temp;
    int public Quantity_Part2_Supplier_temp;

    constructor(string memory description, int price) public
    {
        InstanceBuyer = msg.sender;
        Price = price;
        Description = description;
        
        State = StateType.ItemAvailable;
    }

    function MakeOffer(int offerPrice,int quantity) public
    {
        if (offerPrice == 0)
        {
            revert();
        }
        if (quantity == 0)
        {
            revert();
        }
        if (State == StateType.OrderForSupplier)
        {
            InstanceBuyer = msg.sender;
            Price = offerPrice;
            State = StateType.ShipFromSupplier;
        }
    }

    function Reject() public
    {
        if (State == StateType.ShipFromSupplier)
        {
            InstanceBuyer = 0x0000000000000000000000000000000000000000;
            State = StateType.OrderForSupplier;
        }
    }

    function AcceptOffer() public
    {
        if (State == StateType.OrderAcceptedByW1)
        {
            State = StateType.OrderForODM;
        }
        else if (State == StateType.OrderAcceptedByW2)
        {
            State = StateType.OrderForODM;
        }
        else if(State == StateType.OrderForODM)
        {
            State = StateType.OrderForSupplier;
        }
        else if(State == StateType.ShipFromSupplier)
        {
            InstanceSupplier = msg.sender;
            State = StateType.ItemSent;
            
        }
    }

    function Requirement_W1(int quantity_w1) public
    {
        if((Quantity_W1 - quantity_w1) > 50)
        {
            Quantity_W1 = Quantity_W1 - quantity_w1;
            State = StateType.ItemSent;
            
        }
        if(State == StateType.ItemAvailable)
        {
            Quantity_ODM = quantity_w1 - (Quantity_W1 - 50);
            State = StateType.OrderAcceptedByW1;
            Requirement_ODM(Quantity_ODM);
        }
    }
    function Requirement_W2(int quantity_w2) public
    {
        if((Quantity_W2 - quantity_w2) > 50)
        {
            Quantity_W2 = Quantity_W2 - quantity_w2;
            State = StateType.ItemSent;
        }
        if(State == StateType.ItemAvailable)
        {
            Quantity_ODM = quantity_w2 - (Quantity_W2 - 50);
            State = StateType.OrderAcceptedByW2;
            Requirement_ODM(Quantity_ODM);
        }
    }
    function Requirement_ODM(int quantity_odm) public
    {
        if(State == StateType.OrderForODM)
        {
            
            Quantity_Part1_Supplier = Quantity_Part1_Supplier - Quantity_Part1_Supplier_temp;
            Quantity_Part2_Supplier = Quantity_Part2_Supplier - Quantity_Part2_Supplier_temp;
            State = StateType.OrderForSupplier;
        }
        if(quantity_odm % 2 == 0)
        {
            Quantity_Part1_Supplier = Quantity_Part2_Supplier = quantity_odm / 2;
        }
        else 
        {
            Quantity_Part1_Supplier_temp = (quantity_odm + 1) / 2;
            Quantity_Part2_Supplier_temp = quantity_odm - Quantity_Part1_Supplier;
            
        }      
    }
}