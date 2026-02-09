# Defined in - @ line 1
function open --description 'Open folder or file in Windows Explorer'
  set -l target "."
  if test (count $argv) -gt 0
    set target $argv[1]
  end

  set -l winpath (wslpath -w $target)
  
  # Silence UNC warning by jumping to C: temporarily
  pushd /mnt/c
  cmd.exe /c start "" "$winpath" >/dev/null 2>&1
  popd
end
