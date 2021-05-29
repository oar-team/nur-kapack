#!/usr/bin/env python3
import json
import pytest
import shlex
import subprocess

def run_cmd_parse_json(cmd, input=None):
    '''Run a command and return its parsed JSON output.'''
    p = subprocess.Popen(shlex.split(cmd), stdin=subprocess.PIPE, stdout=subprocess.PIPE, stderr=subprocess.PIPE, encoding='utf-8')
    out, err = p.communicate(input=input)
    if p.returncode != 0:
        print(f'process failed: {cmd}')
        if input: print(f"stdin:\n--- BEGIN OF STDIN LOG ---\n{input}\n--- END OF STDIN LOG---")
        if out: print(f"stdout: {out}")
        if err: print(f"stderr: {err}")
        raise Exception(f'Process failed (returned {p.returncode})')

    return json.loads(out)

def generate_attributes():
    '''Return a dict of attribute names to build.'''
    return run_cmd_parse_json("nix eval --json -f ci.nix 'pkgs-names-to-build'")

def generate_attributes_with_inputs():
    '''Return a dict of attributes with their inputs.'''
    return run_cmd_parse_json("nix eval --json -f ci.nix 'pkgs-to-build-with-deps'")


def pytest_generate_tests(metafunc):
    if 'attribute' in metafunc.fixturenames:
        metafunc.parametrize('attribute', generate_attributes())
    if 'attributes_with_inputs' in metafunc.fixturenames:
        metafunc.parametrize('attributes_with_inputs', [generate_attributes_with_inputs()])

def pytest_addoption(parser):
    parser.addoption("--cachix-name", action="store", default="batsim", help="name on the cachix binary cache to push packages onto")
    parser.addoption("--push-deps-on-cachix", action="store_true", default=False, help="push package build deps on cachix before building it")
    parser.addoption("--push-on-cachix", action="store_true", default=False, help="push a package on cachix after building it")
