function mission_state = Rec_PRM_Rec_state()


mission_state_sub = rossubscriber("/CZflie/TC/mission_state","std_msgs/String");

msg = receive(mission_state_sub);
mission_state = msg.Data;
disp(['new state is: ', mission_state])