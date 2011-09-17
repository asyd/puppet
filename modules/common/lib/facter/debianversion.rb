Facter.add(:debianversion) do
	setcode do
		version = ""
		if FileTest.exists?("/etc/debian_version")
			txt = File.read("/etc/debian_version")
			if txt =~ /^6.0/
				version = "squeeze"
			end
		end
		version
	end
end
