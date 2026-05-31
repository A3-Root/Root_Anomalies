#include "\z\root_anomalies\addons\main\script_component.hpp"
/*
 * Author: Root
 * Description: Shared "is this observer looking at the anomaly" test, used by SCP-173
 *              (excludeCameras = true: UAV terminals / external camera feeds do NOT
 *              count, only the observer's own eyes or binoculars) and SCP-096
 *              (excludeCameras = false: any camera feed counts). Checks view cone +
 *              line of sight. For AI the body facing is used; for the local player the
 *              actual render-camera direction is used.
 *
 * Arguments:
 * 0: Observer <OBJECT>
 * 1: Anomaly object <OBJECT>
 * 2: View cone half-angle in degrees <NUMBER> (default 55)
 * 3: Anomaly head height offset (m) <NUMBER> (default 1.5)
 * 4: Exclude camera/UAV feeds <BOOL> (default true)
 *
 * Return Value:
 * Observer currently sees the anomaly <BOOL>
 *
 * Example:
 * [player, _scp, 55, 1.5, true] call EFUNC(main,isObserving);
 *
 * Public: No
 */

params [["_observer", objNull, [objNull]], ["_obj", objNull, [objNull]], ["_cone", 55, [0]], ["_headOffset", 1.5, [0]], ["_excludeCameras", true, [false]]];

if (isNull _observer || {isNull _obj} || {!alive _observer}) exitWith {false};

private _isLocalPlayer = !isNull player && {_observer isEqualTo player};

// Camera/UAV exclusion: only honoured for the local player. When excluding, the render
// camera must be the player's own body or vehicle (not a UAV terminal / spectator cam).
if (_excludeCameras && _isLocalPlayer && {!(cameraOn in [_observer, vehicle _observer])}) exitWith {false};

private _eye = eyePos _observer;
private _head = (AGLToASL (getPosATL _obj)) vectorAdd [0, 0, _headOffset];
private _toObj = _head vectorDiff _eye;
private _viewDir = [vectorDir _observer, getCameraViewDirection _observer] select _isLocalPlayer;

private _angle = acos (((_viewDir vectorDotProduct (vectorNormalized _toObj)) min 1) max -1);
if (_angle >= _cone) exitWith {false};

(lineIntersectsSurfaces [_eye, _head, _observer, _obj]) isEqualTo []
