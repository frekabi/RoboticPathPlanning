function Rec_PRM_Com_Send_IMP(PathPoints,EndPoint)

pos_com_send_pub = rospublisher("/CZflie/RC/pos_com","geometry_msgs/Pose");
tgt_com_send_pub = rospublisher("/CZflie/RC/tgt_com","geometry_msgs/Pose");
last_district = rospublisher("/CZflie/RC/last_target","std_msgs/String");

pos_msg = rosmessage(pos_com_send_pub);
tgt_msg = rosmessage(tgt_com_send_pub);
ltarget_msg = rosmessage(last_district);

if EndPoint == 1
    ltarget_msg.Data = 'Y'
else
    ltarget_msg.Data = 'N'
end

[r,c] = size(PathPoints);
target_point = PathPoints(end,:);
tgt_msg.Position.X = target_point(1);
tgt_msg.Position.Y = target_point(2);
tgt_msg.Position.Z = target_point(3);


i = 1;
while i  <= r
    mission_state = Rec_PRM_Rec_state();
%     mission_state = 'MoveToNextTgt';
    switch mission_state 
        case 'MoveToNextTgt'
            pos_msg.Position.X = PathPoints(i,1);
            pos_msg.Position.Y = PathPoints(i,2);
            pos_msg.Position.Z = PathPoints(i,3);
            send(pos_com_send_pub,pos_msg)
            send(tgt_com_send_pub,tgt_msg)
            send(last_district,ltarget_msg)
            disp('Command sent')
            pause(1)
            i = i + 1;
        otherwise
            continue
    end
end


