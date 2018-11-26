public class MovingObject
{
  PVector mPosition;
  PVector mVelocity; 
  PVector mAcceleration;
  float maxforce = 0.5;
  float maxspeed = 4;

  public MovingObject()
  {
    mAcceleration = new PVector(0, 0);
    mVelocity = new PVector(0, -2);
    mPosition = new PVector(0, 180);
  }

  public void updatePosition()
  {
    // Update velocity
    mVelocity.add(mAcceleration);
    // Limit speed
    mVelocity.limit(maxspeed);
    mPosition.add(mVelocity);
    // Reset accelerationelertion to 0 each cycle
    mAcceleration.mult(0);
  }

  void applyForce(PVector force)
  {
    mAcceleration.add(force);
  }

  void seek(PVector target) 
  {
    PVector desired = PVector.sub(target, mPosition);  // A vector pointing from the position to the target

    //print("seeking:"+target);
    // Scale to maximum speed
    desired.setMag(maxspeed);

    // Steering = Desired minus velocity
    PVector steer = PVector.sub(desired, mVelocity);
    steer.limit(maxforce);  // Limit to maximum steering force

    applyForce(steer);
  }
}
