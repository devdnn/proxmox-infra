#!/usr/bin/env python3
import requests
import json
import sys
import urllib3

API_URL = "https://192.168.1.11:8006/api2/json"
USERNAME = "root@pam"
PASSWORD = "Float12345678"

urllib3.disable_warnings(urllib3.exceptions.InsecureRequestWarning)

def get_auth_token():
    auth_url = f"{API_URL}/access/ticket"
    response = requests.post(auth_url, data={'username': USERNAME, 'password': PASSWORD}, verify=False)
    data = response.json()
    return data['data']['ticket'], data['data']['CSRFPreventionToken']

def find_keys_with_prefix(data, target_key, prefix, results=None):
    if results is None:
        results = []
    if isinstance(data, dict):
        for key, value in data.items():
            if key == target_key and isinstance(value, str) and value.startswith(prefix):
                results.append(value)
            elif isinstance(value, (dict, list)):  # Recursive call for deeper search
                find_keys_with_prefix(value, target_key, prefix, results)
    elif isinstance(data, list):
        for item in data:
            find_keys_with_prefix(item, target_key, prefix, results)
    return results

def get_vm_list(auth_token, csrf_token):
    headers = {
        'Cookie': f"PVEAuthCookie={auth_token}",
        'CSRFPreventionToken': csrf_token
    }
    nodes_url = f"{API_URL}/nodes"
    nodes_response = requests.get(nodes_url, headers=headers, verify=False)
    nodes = nodes_response.json()['data']
    
    inventory = {
        'linux_vms_and_lxcs': {'hosts': [], 'vars': {}},
        '_meta': {'hostvars': {}}
    }
    for node in nodes:
        for vm_type in ['qemu', 'lxc']:
            vms_url = f"{API_URL}/nodes/{node['node']}/{vm_type}"
            vms_response = requests.get(vms_url, headers=headers, verify=False)
            vms = vms_response.json()['data']
            for vm in vms:
                if(vm_type == 'qemu'):
                    vm_status_url = f"{API_URL}/nodes/{node['node']}/{vm_type}/{vm['vmid']}/status/current"
                    vm_status_response = requests.get(vm_status_url, headers=headers, verify=False)
                    vm_status = vm_status_response.json()['data']
                    if vm_status['status'] != 'running' or ('agent' in vm_status and vm_status['agent'] != 1):
                        continue
                    vm_config_url = f"{API_URL}/nodes/{node['node']}/{vm_type}/{vm['vmid']}/config"
                    vm_config_response = requests.get(vm_config_url, headers=headers, verify=False)
                    vm_config = vm_config_response.json()['data']
                    # Assume 'ostype' key exists and holds OS information, adjust based on actual API response
                    if 'ostype' in vm_config and 'l26' in vm_config['ostype'].lower():
                            vm_network_interfaces_url = f"{API_URL}/nodes/{node['node']}/{vm_type}/{vm['vmid']}/agent/network-get-interfaces"
                            vm_network_interfaces_response = requests.get(vm_network_interfaces_url, headers=headers, verify=False)
                            results = find_keys_with_prefix(vm_network_interfaces_response.json(), 'ip-address', '192.168', [])
                            if len(results) > 0:
                                inventory['linux_vms_and_lxcs']['hosts'].append(vm['name'])
                                inventory['_meta']['hostvars'][vm['name']] = {
                                    'ansible_host': results[0]
                                }
                elif(vm_type == 'lxc'):
                    if(vm['status'] != 'running'):
                        continue
                    vm_network_interfaces_url = f"{API_URL}/nodes/{node['node']}/{vm_type}/{vm['vmid']}/agent/network-get-interfaces"
                    vm_network_interfaces_response = requests.get(vm_network_interfaces_url, headers=headers, verify=False)
                    results = find_keys_with_prefix(vm_network_interfaces_response.json(), 'ip-address', '192.168', [])
                    if len(results) > 0:
                        inventory['linux_vms_and_lxcs']['hosts'].append(vm['name'])
                        inventory['_meta']['hostvars'][vm['name']] = {
                            'ansible_host': results[0]
                        }
    
    return inventory

if __name__ == "__main__":
    # if len(sys.argv) == 2 and sys.argv[1] == '--list':
        token, csrf = get_auth_token()
        print(json.dumps(get_vm_list(token, csrf),indent=2))
    #else:
    #    print("Usage: {} --list".format(sys.argv[0]))
