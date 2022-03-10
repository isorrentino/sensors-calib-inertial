% definition of the Yarp ports where joint sensors and motion sensors
% (accelerometers, gyroscopes, IMUs and FT sensors) data is published.

joints_port_rule_icub   =        '[''/'' robotname ''/'' part ''/stateExt:o'']';
joints_port_rule_dumper = '[''/dumper/'' robotname ''/'' part ''/stateExt'']';
joints_folder_rule_dumper =             '[datapath ''/'' part ''/stateExt'']';

accSensors_port_rule_icub   =        '[''/'' robotname ''/'' part ''/inertialMTB'']';
accSensors_port_rule_dumper = '[''/dumper/'' robotname ''/'' part ''/inertialMTB'']';
accSensors_folder_rule_dumper =             '[datapath ''/'' part ''/inertialMTB'']';

imuSensors_port_rule_icub   =        '[''/'' robotname ''/inertial'']';
imuSensors_port_rule_dumper = '[''/dumper/'' robotname ''/inertial'']';
imuSensors_folder_rule_dumper =  '[datapath ''/'' part ''/inertial'']';

% Non multisens ft port
% FTSensors_port_rule_icub   =        '[''/'' robotname ''/'' part ''/analog:o'']';
% FTSensors_port_rule_dumper = '[''/dumper/'' robotname ''/'' part ''/analog'']';
% FTSensors_folder_rule_dumper =             '[datapath ''/'' part ''/analog'']';

% For the multisens ft port
FTSensors_port_rule_icub   =        '[''/'' robotname ''/'' part ''/analog:o'']';
FTSensors_port_rule_dumper = '[''/dumper/'' robotname ''/'' part ''/analog'']';
FTSensors_folder_rule_dumper =             '[datapath ''/'' part ''/analog'']';

