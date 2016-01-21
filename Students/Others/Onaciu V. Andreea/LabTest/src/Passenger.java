import java.util.UUID;

public class Passenger implements Carriable{

	private final String name;
	
	public Passenger(){
		this.name=UUID.randomUUID().toString();
	}
	
	public String getName(){
		return this.name;
	}
	
}
