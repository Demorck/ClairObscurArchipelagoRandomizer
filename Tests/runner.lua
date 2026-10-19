---Minimal test runner: no dependency and exits 1 when something fails
local Runner = { passed = 0, failed = 0, failures = {} }

function Runner.test(name, fn)
    local ok, err = xpcall(fn, debug.traceback)
    if ok then
        Runner.passed = Runner.passed + 1
    else
        Runner.failed = Runner.failed + 1
        Runner.failures[#Runner.failures + 1] = name .. "\n" .. tostring(err)
    end
end

function Runner.check(condition, message)
    if not condition then error(message or "check failed", 2) end
end

function Runner.equal(actual, expected, message)
    if actual ~= expected then
        error(("%s\n  expected: %s\n  actual:   %s")
            :format(message or "values differ", tostring(expected), tostring(actual)), 2)
    end
end

function Runner.report()
    for _, failure in ipairs(Runner.failures) do
        print("FAIL  " .. failure .. "\n")
    end
    print(("%d passed, %d failed"):format(Runner.passed, Runner.failed))
    os.exit(Runner.failed == 0 and 0 or 1)
end

return Runner