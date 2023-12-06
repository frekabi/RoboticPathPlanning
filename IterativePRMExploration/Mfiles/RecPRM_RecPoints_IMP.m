function Points = RecPRM_RecPoints_IMP(time,freq)

ts = 1/freq;
count = round(time * freq) + 1;

pointcloud_sub = rossubscriber("/CZflie/TC/MR_pointcloud_topic","sensor_msgs/PointCloud");


Points_Cld = [];
for i = 1:count
    pcld = receive(pointcloud_sub);
    for k = 1:length(pcld.Points)
        disp('receiving new point cloud')
        Points_Cld = [Points_Cld;[pcld.Points(k,1).X pcld.Points(k,1).Y pcld.Points(k,1).Z]];
    end
    pause(ts)
end


Points = Points_Cld;