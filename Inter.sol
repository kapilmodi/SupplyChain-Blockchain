pragma solidity >=0.4.25 <0.6.0;

contract Inter
{
    enum StateType { 
      ItemAvailable,
      OrderAccepted,
      OrderReceived,
      ProductRequest,
      ProductReceived
    }

    address public InstanceBuyer;
    string public Description;
    int public OrderPriceProd;
    int public ProductOfferPrice;
    int public ProductPrice;
    StateType public State;
    address public ConsumerName;
    int public Quantity;

    address public InstanceSupplier;
    int public OrderOfferPriceSupp;

    constructor(string memory description, int price, int quantity) public
    {
        InstanceBuyer = msg.sender;
        OrderPriceProd = price;
        Description = description;
        Quantity = quantity;
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
       
        
        if (State == StateType.ItemAvailable)
        {
            InstanceBuyer = msg.sender;
            OrderOfferPriceSupp = offerPrice;
            State = StateType.OrderAccepted;
        }
        if (State == StateType.OrderReceived)
        {
            ConsumerName = msg.sender;
            ProductOfferPrice = offerPrice;
            State = StateType.ProductRequest;
        }
    }

    function Reject() public
    {
        

        if (State == StateType.OrderAccepted)
        {
            InstanceBuyer = 0x0000000000000000000000000000000000000000;
            State = StateType.ItemAvailable;
        }
       
        if (State == StateType.ProductRequest)
        {
            
            State = StateType.OrderReceived;
        }

        
    }

    function AcceptOffer() public
    {
        
        if (State == StateType.OrderAccepted)
        {
            State = StateType.OrderReceived;
        }
        
        if (State == StateType.ProductRequest)
        {
            State = StateType.ProductReceived;
        }
    }
}