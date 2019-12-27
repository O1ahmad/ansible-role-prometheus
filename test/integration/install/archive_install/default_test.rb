title "Prometheus archive installation test suite"

describe user('prometheus') do
  it { should exist }
end

describe group('prometheus') do
  it { should exist }
end
